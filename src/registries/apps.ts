// Packages
import { Source } from "@rbxts/vide";

// Types
import type Types from "@root/types";

export type RegistryMap<N> = Map<AppNames, Map<AppGroups, N>>;
export type AnyAppEntry<N extends AppNames = AppNames> =
	| Types.Decorator.Entry<N>
	| Types.Decorator.ChildEntry<N>;

export const AppRegistry: RegistryMap<AnyAppEntry> = new Map();
export const AppSources: RegistryMap<Source<boolean>> = new Map();
/**
 * Optional per-app visibility source used for render-time animation state.
 * Falls back to AppSources when not set.
 */
export const AppDisplaySources: RegistryMap<Source<boolean>> = new Map();
