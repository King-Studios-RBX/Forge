// Services
import { Workspace } from "@rbxts/services";
// Packages
import Vide, { show, source } from "@rbxts/vide";
// Types
import type Types from "@root/types";
// Components
import { AppDisplaySources, AppRegistry } from "@registries/apps";
// Hooks
import { usePx } from "@hooks/usePx";
// Classes
import Rules from "@managers/rules";
// Helpers
import isChildAppRules from "@helpers/isChildAppRules";
import isChildEntry from "@helpers/isChildEntry";
import getAppEntry from "@helpers/getAppEntry";
import getAppSource from "@helpers/getAppSource";
import hasAppSource from "@helpers/hasAppSource";
import setAppSource from "@helpers/setAppSource";
// Renders
import createInstance, { type Render } from "./createInstance";
// Logger
import Logger from "@root/logger";

export default class Renders extends Rules {
	protected Loaded = new Map<AppNames, Map<AppGroups, Render>>();
	private __initalize = false;

	constructor() {
		super();
	}

	protected Initialize(props: Types.Props.Main) {
		if (!this.__initalize) {
			usePx(
				props.config?.px?.target || Workspace.CurrentCamera,
				props.config?.px?.resolution,
				props.config?.px?.minScale,
			);
			this.__initalize = true;
		}
		return this.Load(props);
	}

	private Load(props: Types.Props.Main) {
		const renders = props.renders;
		const mountWhenVisible = props.config?.render?.mountWhenVisible ?? false;
		const unmountOnHide = props.config?.render?.unmountOnHide ?? true;

		const names =
			renders?.name !== undefined
				? new Set([renders.name])
				: renders?.names !== undefined
					? new Set(renders.names)
					: undefined;

		const groups =
			renders?.group !== undefined
				? new Set([renders.group])
				: renders?.groups !== undefined
					? new Set(renders.groups)
					: undefined;

		const load: Exclude<Vide.Node, undefined>[] = [];
		const rendered = new Set<string>();

		// Time the entire load pass
		const start = os.clock();

		const removeLoadedRender = (name: AppNames, group: AppGroups, render: Render) => {
			render.container.Destroy();
			const entryMap = this.Loaded.get(name);
			if (!entryMap) return;
			entryMap.delete(group);
			if (entryMap.size() === 0) {
				this.Loaded.delete(name);
			}
		};

		const setDisplaySource = (name: AppNames, group: AppGroups, visibilitySource: Vide.Source<boolean>) => {
			const sourceMap = AppDisplaySources.get(name) ?? new Map<AppGroups, Vide.Source<boolean>>();
			sourceMap.set(group, visibilitySource);
			AppDisplaySources.set(name, sourceMap);
		};

		const clearDisplaySource = (name: AppNames, group: AppGroups) => {
			const sourceMap = AppDisplaySources.get(name);
			if (!sourceMap) return;
			sourceMap.delete(group);
			if (sourceMap.size() === 0) {
				AppDisplaySources.delete(name);
			}
		};

		const renderEntry = (name: AppNames, group: AppGroups): Exclude<Vide.Node, undefined> | undefined => {
			const key = `${name}:${group}`;
			if (rendered.has(key)) return;
			rendered.add(key);

			const entry = getAppEntry(name, group);
			if (!entry) return;
			const shouldPushToRoot = !isChildAppRules(entry.rules) || entry.rules.detached;

			// Create source for this app if it doesn't exist yet
			if (!hasAppSource(name, group)) {
				setAppSource(name, group, entry.visible ?? false);
			}

			// Collect all direct child containers before building this container
			const childContainers: Exclude<Vide.Node, undefined>[] = [];
			AppRegistry.forEach((groupEntries) => {
				groupEntries.forEach((childEntry, childGroup) => {
					if (!isChildEntry(childEntry)) return;
					if (childEntry.rules.detached) return;
					if (childEntry.rules.parent !== name) return;
					const childParentGroup = childEntry.rules.parentGroup ?? "None";
					if (childParentGroup !== group) return;
					const childContainer = renderEntry(childEntry.name, childGroup);
					if (childContainer) childContainers.push(childContainer);
				});
			});

			if (!mountWhenVisible) {
				clearDisplaySource(name, group);
				const render = createInstance(props, name, group, childContainers, this.Loaded);
				if (!render) return;

				if (shouldPushToRoot) {
					load.push(render.container);
				}

				return render.container;
			}

			let activeRender: Render | undefined;
			const appSource = getAppSource(name, group);
			const node = unmountOnHide
				? show(
						() => appSource(),
						(_, present) => {
							setDisplaySource(name, group, present);
							if (!activeRender) {
								activeRender = createInstance(props, name, group, childContainers, this.Loaded);
							}

							return activeRender?.container;
						},
						() => {
							clearDisplaySource(name, group);
							if (activeRender) {
								removeLoadedRender(name, group, activeRender);
								activeRender = undefined;
							}

							return undefined;
						},
					)
				: (() => {
						const keepMounted = source(false);

						return show(
							() => appSource() || keepMounted(),
							() => {
								setDisplaySource(name, group, appSource);
								if (!activeRender) {
									activeRender = createInstance(props, name, group, childContainers, this.Loaded);
								}

								if (activeRender) {
									keepMounted(true);
								}

								return activeRender?.container;
							},
						);
					})();

			if (shouldPushToRoot) {
				load.push(node);
			}

			return node;
		};

		AppRegistry.forEach((groupEntries, appName) => {
			groupEntries.forEach((entry, group) => {
				if (isChildEntry(entry) && !entry.rules.detached) return;
				if (names && !names.has(appName)) return;
				if (groups && !groups.has(group)) return;
				renderEntry(appName, group);
			});
		});

		const elapsed = os.clock() - start;
		Logger.debug(
			"Renders",
			`Load completed in ${string.format("%.4f", elapsed)}s — ${rendered.size()} app node(s) prepared`,
		);

		return load;
	}
}
