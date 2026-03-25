import { Source } from "@rbxts/vide";
import type Types from "../types/index";
export type RegistryMap<N> = Map<AppNames, Map<AppGroups, N>>;
export type AnyAppEntry<N extends AppNames = AppNames> = Types.Decorator.Entry<N> | Types.Decorator.ChildEntry<N>;
export declare const AppRegistry: RegistryMap<AnyAppEntry>;
export declare const AppSources: RegistryMap<Source<boolean>>;
