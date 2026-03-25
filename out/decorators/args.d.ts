import { Source } from "@rbxts/vide";
import type { AppForge } from "../forge";
import type Types from "../types/index";
declare abstract class BaseArgs {
    readonly forge: AppForge;
    readonly props: Types.Props.Class;
    readonly name: AppNames;
    readonly group: AppGroups;
    readonly source: Source<boolean>;
    protected constructor(entry: Types.Decorator.Entry | Types.Decorator.ChildEntry, props: Types.Props.Main);
    abstract render(): AppForge.Node;
}
export declare abstract class Args extends BaseArgs {
    constructor(entry: Types.Decorator.Entry, props: Types.Props.Main);
}
export declare abstract class ChildArgs extends BaseArgs {
    readonly childrenSources: () => Source<boolean>[];
    readonly closeChildren: () => void;
    readonly parentSource: Source<boolean>;
    constructor(entry: Types.Decorator.ChildEntry, props: Types.Props.Main);
}
export {};
