// Types
import type Types from "@root/types";

// Dependencies
import { AppRegistry } from "@registries/apps";

export default function ChildApp<N extends AppNames>(props: Types.Decorator.ChildAppProps<N>) {
	return function <T extends Types.Decorator.ChildConstructor<N>>(constructor: T) {
		const groupKey = props.group ?? "None";

		// Ensure uniqueness
		if (AppRegistry.get(props.name)?.has(groupKey)) {
			error(
				`Duplicate registered App name "${props.name}" in same Group "${groupKey}". ` +
					`App names must be globally unique.`,
				2,
			);
		}

		if (!props.name) error("App registration failed: missing app name", 2);

		// Initialize registry map if missing
		if (!AppRegistry.has(props.name)) AppRegistry.set(props.name, new Map());

		// Register app
		AppRegistry.get(props.name)!.set(groupKey, {
			constructor,
			name: props.name,
			group: props.group,
			visible: props.visible,
			zIndex: props.zIndex,
			rules: props.rules,
		} as Types.Decorator.ChildEntry<N>);

		return constructor;
	};
}
