// Packages
import { effect, untrack } from "@rbxts/vide";

// Types
import type { AppForge } from "@root/forge";

// Rules
import ParentRule from "./checks/parent";
import ExclusiveGroupRule from "./checks/exclusiveGroup";

// Components
import { AppRegistry } from "@registries/apps";

// Helpers
import hasAppSource from "@helpers/hasAppSource";
import getAppSource from "@helpers/getAppSource";

export default class Rules {
	protected processing = new Set<string>();

	protected setupRuleEffects(forge: AppForge) {
		AppRegistry.forEach((entryMap, name) => {
			entryMap.forEach((_, group) => {
				if (!hasAppSource(name, group)) return;
				effect(() => {
					getAppSource(name, group)();
					untrack(() => this.checkRules(forge, name, group));
				});
			});
		});
	}

	protected checkRules(forge: AppForge, name: AppNames, group: AppGroups) {
		const key = `${name}:${group}`;
		if (this.processing.has(key)) return;
		this.processing.add(key);
		try {
			ParentRule(forge, name, group);
			ExclusiveGroupRule(forge, name, group);
		} finally {
			this.processing.delete(key);
		}
	}
}
