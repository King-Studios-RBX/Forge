import Vide from "@rbxts/vide";
import type Types from "../types/index";
type Render = {
    instance: Instance;
    container: Instance;
    anchor: Instance | undefined;
    entry: Types.Decorator.Entry | Types.Decorator.ChildEntry;
};
export default function createInstance(props: Types.Props.Main, name: AppNames, group: AppGroups, childContainers: Exclude<Vide.Node, undefined>[], Loaded: Map<AppNames, Map<AppGroups, Render>>): Render | undefined;
export type { Render };
