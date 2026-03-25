import type Types from "../types/index";
import Rules from "../managers/rules/index";
import { type Render } from "./createInstance";
export default class Renders extends Rules {
    protected Loaded: Map<string, Map<string, Render>>;
    private __initalize;
    constructor();
    protected Initialize(props: Types.Props.Main): Instance[];
    private Load;
}
