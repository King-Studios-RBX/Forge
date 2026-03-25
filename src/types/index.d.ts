// Types
import type { Args, ChildArgs } from "@root/decorators";
import type { AppForge } from "@root/forge";

declare namespace Types {
	/* =======================
	 * Props
	 * ======================= */
	namespace Render {
		type NameSelector = { name: AppNames; names?: never } | { names: AppNames[]; name?: never };
		type GroupSelector =
			| { group: AppGroups; groups?: never }
			| { groups: AppGroups[]; group?: never };

		type NameOnly = { name: AppNames; names?: never; group?: never; groups?: never };
		type NamesOnly = { names: AppNames[]; name?: never; group?: never; groups?: never };
		type GroupOnly = { group: AppGroups; groups?: never; name?: never; names?: never };
		type GroupsOnly = { groups: AppGroups[]; group?: never; name?: never; names?: never };
		type NameAndGroup = { name: AppNames; names?: never; group: AppGroups; groups?: never };
		type NameAndGroups = { name: AppNames; names?: never; groups: AppGroups[]; group?: never };
		type NamesAndGroup = { names: AppNames[]; name?: never; group: AppGroups; groups?: never };
		type NamesAndGroups = { names: AppNames[]; name?: never; groups: AppGroups[]; group?: never };

		export type Props =
			| NameOnly
			| NamesOnly
			| GroupOnly
			| GroupsOnly
			| NameAndGroup
			| NameAndGroups
			| NamesAndGroup
			| NamesAndGroups;
	}

	/* =======================
	 * Props
	 * ======================= */
	namespace Props {
		export type Main = {
			props: AppProps;
			forge: AppForge;
			config?: Config;
			renders?: Render.Props;
		};

		export type Config = {
			px?: {
				target?: GuiObject | Camera;
				resolution?: Vector2;
				minScale?: number;
			};
		};

		export type Class = AppProps & {
			screen: typeof import("../hooks/usePx").screen;
			px: typeof import("../hooks/usePx").px;
		};
	}

	/* =======================
	 * Rules
	 * ======================= */
	namespace Rules {
		type WithParent<P extends AppNames = AppNames> = {
			parent: P;
			parentGroup?: AppGroups;
			anchor?: boolean;
		};

		export type App = {
			/** When set, only one app in the same exclusiveGroup can be visible at a time. */
			exclusiveGroup?: string;
		};

		export type ChildApp = {
			/** When set, only one app in the same exclusiveGroup can be visible at a time. */
			exclusiveGroup?: string;
		} & WithParent;
	}

	/* =======================
	 * App Registry
	 * ======================= */
	namespace Fade {
		export type Config = {
			period?: number;
			dampeningRatio?: number;
		};

		export type Constructor = {
			__forge_fade?: Fade.Config;
		};
	}

	/* =======================
	 * App Registry
	 * ======================= */
	namespace Decorator {
		export type Constructor<N extends AppNames = AppNames> = new (
			entry: Entry<N>,
			props: Props.Main,
		) => Args;

		export type ChildConstructor<N extends AppNames = AppNames> = new (
			entry: ChildEntry<N>,
			props: Props.Main,
		) => ChildArgs;

		export type Entry<N extends AppNames = AppNames> = {
			constructor: Constructor<N>;
			name: AppNames;
			group?: AppGroups;
			visible?: boolean;
			zIndex?: number;

			rules?: Rules.App;
			fade?: Fade.Config;
		};

		export type ChildEntry<N extends AppNames = AppNames> = {
			constructor: ChildConstructor<N>;
			name: AppNames;
			group?: AppGroups;
			visible?: boolean;
			zIndex?: number;

			rules: Rules.ChildApp;
			fade?: Fade.Config;
		};

		export type AppProps<N extends AppNames = AppNames> = {
			name: N;
			group?: AppGroups;
			visible?: boolean;
			zIndex?: number;

			rules?: Rules.App;
		};
		export type ChildAppProps<N extends AppNames = AppNames> = {
			name: N;
			group?: AppGroups;
			visible?: boolean;
			zIndex?: number;

			rules: Rules.ChildApp;
		};
	}
}

export type ForgeProps = Types.Props.Main;
export type ClassProps = Types.Props.Class;
export type RenderProps = Types.Render.Props;

export default Types;
