// Packages
import type { Node as VideNode } from "@rbxts/vide";
import type Types from ".";

declare global {
	// These will be overridden by the user
	// They are only placeholders for your build

	// HELPERS FOR AUTOCOMPLETION TYPES
	namespace AppForge {
		type Node = VideNode;

		type AppEntry = Types.Decorator.Entry;

		namespace Props {
			type Config = Types.Props.Config;
			type Render = Types.Render.Props;
			type Class = Types.Props.Class;
			type Main = Types.Props.Main;
		}
	}
}
export {};
