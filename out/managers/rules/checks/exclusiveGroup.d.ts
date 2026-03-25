import type { AppForge } from "../../../forge";
/**
 * ExclusiveGroupRule
 *
 * When an app with an `exclusiveGroup` becomes visible, all other apps
 * sharing the same `exclusiveGroup` value are automatically closed.
 * This ensures only one app in the group is visible at a time.
 */
export default function ExclusiveGroupRule(forge: AppForge, name: AppNames, group: AppGroups): void;
