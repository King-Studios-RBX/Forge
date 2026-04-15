// Services
import { Workspace } from "@rbxts/services";
// Types
import type Types from "@root/types";
// Components
import { AppRegistry } from "@registries/apps";
// Hooks
import { usePx } from "@hooks/usePx";
// Classes
import Rules from "@managers/rules";
// Helpers
import isChildAppRules from "@helpers/isChildAppRules";
import isChildEntry from "@helpers/isChildEntry";
import getAppEntry from "@helpers/getAppEntry";
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

		const load: Instance[] = [];
		const rendered = new Set<string>();

		// Time the entire load pass
		const start = os.clock();

		const renderEntry = (name: AppNames, group: AppGroups): Instance | undefined => {
			const key = `${name}:${group}`;
			if (rendered.has(key)) return;
			rendered.add(key);

			// Create source for this app if it doesn't exist yet
			if (!hasAppSource(name, group)) {
				const entry = getAppEntry(name, group);
				setAppSource(name, group, entry.visible ?? false);
			}

			// Collect all direct child containers before building this container
			const childContainers: Instance[] = [];
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

			const render = createInstance(props, name, group, childContainers, this.Loaded);
			if (!render) return;

			const rules = getAppEntry(name, group)?.rules;
			if (!isChildAppRules(rules) || rules.detached) {
				load.push(render.container);
			}

			return render.container;
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
			`Load completed in ${string.format("%.4f", elapsed)}s — ${rendered.size()} app(s) rendered`,
		);

		return load;
	}
}
