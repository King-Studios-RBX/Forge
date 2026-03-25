import Vide from "@rbxts/vide";
import type Types from "./types/index";
import Renders from "./renders/index";
export declare class AppForge extends Renders {
    constructor();
    bind(name: AppNames, group: AppGroups | undefined, value: Vide.Source<boolean>): void;
    set(name: AppNames, group: AppGroups | undefined, value: boolean): void;
    get(name: AppNames, group?: AppGroups): Vide.Source<boolean> | undefined;
    open(name: AppNames, group?: AppGroups): void;
    close(name: AppNames, group?: AppGroups): void;
    toggle(name: AppNames, group?: AppGroups): void;
    story: ({ props, target, renders, config, }: {
        props: AppProps;
        target: GuiObject;
        renders?: Types.Render.Props;
        config?: Types.Props.Config;
    }) => Frame;
    render: ({ props }: {
        props: Omit<Types.Props.Main, "forge">;
    }) => Instance[];
}
