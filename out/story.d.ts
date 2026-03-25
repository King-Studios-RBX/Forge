import { AppForge } from "./forge";
import Vide from "@rbxts/vide";
import type Types from "./types/index";
export default function Story({ debug, props, target, render, callback, }: {
    debug?: boolean;
    props: AppProps;
    target: GuiObject;
    render?: Types.Render.Props;
    callback?: (props: AppProps, Forge: AppForge) => void;
}): Vide.Node;
