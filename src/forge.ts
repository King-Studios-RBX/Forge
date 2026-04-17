// Packages
import Vide, { apply, create, effect } from "@rbxts/vide";

// Types
import type Types from "@root/types";

// Classes
import Renders from "@root/renders";

// Registries
import { AppDisplaySources, AppSources } from "@registries/apps";

// Helpers
import getAppSource from "@helpers/getAppSource";

export class AppForge extends Renders {
	constructor() {
		super();
	}

	public bind(name: AppNames, group: AppGroups = "None", value: Vide.Source<boolean>) {
		const src = getAppSource(name, group);
		if (!src) return;

		effect(() => {
			src(value());
		});
	}

	// TODO: make a separate files for rules
	public set(name: AppNames, group: AppGroups = "None", value: boolean) {
		let src = getAppSource(name, group);
		if (!src) return;

		const prev = src();
		if (prev === value) return;

		src(value);
	}

	public get(name: AppNames, group: AppGroups = "None") {
		return AppDisplaySources.get(name)?.get(group) ?? AppSources.get(name)?.get(group);
	}
	public open(name: AppNames, group: AppGroups = "None") {
		this.set(name, group, true);
	}
	public close(name: AppNames, group: AppGroups = "None") {
		this.set(name, group, false);
	}
	public toggle(name: AppNames, group: AppGroups = "None") {
		const src = getAppSource(name, group);
		if (!src) return;

		this.set(name, group, !src());
	}

	story = ({
		props,
		target,
		renders,
		config,
	}: {
		props: AppProps;
		target: GuiObject;
		renders?: Types.Render.Props;
		config?: Types.Props.Config;
	}) => {
		const Container = create("Frame")({
			Name: "Story Container",
			BackgroundTransparency: 1,
			AnchorPoint: new Vector2(0.5, 0.5),
			Position: UDim2.fromScale(0.5, 0.5),
			Size: UDim2.fromScale(1, 1),
		});

		apply(Container as Instance)({
			[0]: this.Initialize({
				props,
				forge: this,
				renders,
				config: {
					px: {
						target,
						minScale: config?.px?.minScale,
					},
				},
			}),
		});

		this.setupRuleEffects(this);
		return Container;
	};
	render = ({ props }: { props: Omit<Types.Props.Main, "forge"> }) => {
		const instances = this.Initialize({ ...props, forge: this });
		this.setupRuleEffects(this);
		return instances;
	};
}
