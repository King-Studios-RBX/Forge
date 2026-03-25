// Types
import type { AppForge } from "@root/forge";

// Helpers
import getAppEntry from "@helpers/getAppEntry";
import getAppSource from "@helpers/getAppSource";
import hasAppSource from "@helpers/hasAppSource";

// Registries
import { AppRegistry } from "@registries/apps";

/**
 * ExclusiveGroupRule
 *
 * When an app with an `exclusiveGroup` becomes visible, all other apps
 * sharing the same `exclusiveGroup` value are automatically closed.
 * This ensures only one app in the group is visible at a time.
 */
export default function ExclusiveGroupRule(forge: AppForge, name: AppNames, group: AppGroups) {
	const entry = getAppEntry(name, group);
	if (!entry) return;

	const myExclusiveGroup = entry.rules?.exclusiveGroup;
	if (!myExclusiveGroup) return;

	if (!hasAppSource(name, group)) return;

	const isVisible = getAppSource(name, group)();
	if (!isVisible) return;

	// Close all other apps in the same exclusiveGroup
	AppRegistry.forEach((entryMap, entryName) => {
		entryMap.forEach((otherEntry, entryGroup) => {
			// Skip self
			if (entryName === name && entryGroup === group) return;

			// Skip entries without matching exclusiveGroup
			if (otherEntry.rules?.exclusiveGroup !== myExclusiveGroup) return;

			// Skip entries without a source
			if (!hasAppSource(entryName, entryGroup)) return;

			// Skip already hidden entries
			const visible = getAppSource(entryName, entryGroup)();
			if (!visible) return;

			forge.close(entryName, entryGroup);
		});
	});
}
