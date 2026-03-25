import type Types from "../types/index";
type Render = {
    instance: Instance;
    container: Instance;
    anchor: Instance | undefined;
    entry: Types.Decorator.Entry | Types.Decorator.ChildEntry;
};
export default function createInstance(props: Types.Props.Main, name: AppNames, group: AppGroups, childContainers: Instance[], Loaded: Map<AppNames, Map<AppGroups, Render>>): Render | undefined;
export type { Render };
