// Packages
import Vide, { spring } from "@rbxts/vide";
// Types
import type Types from "@root/types";
// Components
import FadeComponent from "@components/fade";
// Helpers
import isChildAppRules from "@helpers/isChildAppRules";
import isChildEntry from "@helpers/isChildEntry";
import getAppSource from "@helpers/getAppSource";
import getAppEntry from "@helpers/getAppEntry";
// Renders
import createAnchor from "./createAnchor";
// Logger
import Logger from "@root/logger";

type Render = {
	instance: Instance;
	container: Instance;
	anchor: Instance | undefined;
	entry: Types.Decorator.Entry | Types.Decorator.ChildEntry;
};

export default function createInstance(
	props: Types.Props.Main,
	name: AppNames,
	group: AppGroups,
	childContainers: Vide.Node[],
	Loaded: Map<AppNames, Map<AppGroups, Render>>,
): Render | undefined {
	const entry = getAppEntry(name, group);
	if (!entry) return;

	let entryInstance: Instance;
	let anchor: Instance | undefined;
	let parentContainer: Instance | undefined;

	if (isChildEntry(entry)) {
		// Time the child app render
		entryInstance = Logger.time(
			"Renders",
			`${group}:${name}`,
			() => new entry.constructor(entry as never, props).render() as Instance,
		);

		if (!entry.rules.detached) {
			const parentGroup = entry.rules.parentGroup ?? "None";
			const parentMap = Loaded.get(entry.rules.parent);
			if (parentMap) {
				const parentEntry = parentMap.get(parentGroup);
				if (parentEntry) parentContainer = parentEntry.container;
			}

			if (entry.rules.anchor) {
				anchor = createAnchor(entry, props, entryInstance, Loaded);
			}
		}
	} else {
		// Time the root app render
		entryInstance = Logger.time(
			"Renders",
			`${group}:${name}`,
			() => new entry.constructor(entry as never, props).render() as Instance,
		);
	}

	entryInstance.Name = "Render";

	const zIndex = isChildAppRules(entry.rules) ? (entry.zIndex ?? 0) : (entry.zIndex ?? 1);

	let container: Instance;

	if (entry.fade) {
		const source = getAppSource(name, group);
		const [transparencySpring] = spring(
			() => (source() ? 0 : 1),
			entry.fade.period,
			entry.fade.dampeningRatio,
		);
		container = (
			<FadeComponent
				name={`${group}_${name}_Container`}
				groupTransparency={transparencySpring}
				anchor={new Vector2(0.5, 0.5)}
				position={UDim2.fromScale(0.5, 0.5)}
				size={UDim2.fromScale(1, 1)}
				parent={parentContainer}
				zIndex={zIndex}
			>
				{anchor ?? entryInstance}
				{...childContainers}
			</FadeComponent>
		) as Instance;
	} else {
		container = (
			<frame
				Name={`${group}_${name}_Container`}
				BackgroundTransparency={1}
				AnchorPoint={new Vector2(0.5, 0.5)}
				Position={UDim2.fromScale(0.5, 0.5)}
				Size={UDim2.fromScale(1, 1)}
				Parent={parentContainer}
				ZIndex={zIndex}
			>
				{anchor ?? entryInstance}
				{...childContainers}
			</frame>
		) as Instance;
	}

	const render: Render = { container, instance: entryInstance, entry, anchor };
	const entryMap = Loaded.get(name) ?? new Map<AppGroups, Render>();
	entryMap.set(group, render);
	Loaded.set(name, entryMap);

	return render;
}

export type { Render };
