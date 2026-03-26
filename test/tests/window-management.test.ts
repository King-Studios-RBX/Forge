/**
 * Window Management Tests for Forge
 *
 * Tests the ExclusiveGroupRule and ParentRule systems that manage
 * which apps can be visible simultaneously.
 *
 * Uses the same app configuration as Anime Reborn Interface.
 */
import { describe, test, expect, beforeEach } from "bun:test";
import { source, effect, untrack, batch, type Source } from "../shims/rbxts-vide";

// Import the core modules directly
import { AppRegistry, AppSources, type AnyAppEntry } from "../../src/registries/apps";
import setAppSource from "../../src/helpers/setAppSource";
import getAppSource from "../../src/helpers/getAppSource";
import hasAppSource from "../../src/helpers/hasAppSource";
import ExclusiveGroupRule from "../../src/managers/rules/checks/exclusiveGroup";
import ParentRule from "../../src/managers/rules/checks/parent";

// ------------------------------------------------------------------
// Test Helpers
// ------------------------------------------------------------------

type MockForge = {
	open: (name: string, group?: string) => void;
	close: (name: string, group?: string) => void;
	set: (name: string, group: string | undefined, value: boolean) => void;
	get: (name: string, group?: string) => Source<boolean> | undefined;
};

function createMockForge(): MockForge {
	return {
		open(name: string, group = "None") {
			this.set(name, group, true);
		},
		close(name: string, group = "None") {
			this.set(name, group, false);
		},
		set(name: string, group: string | undefined, value: boolean) {
			const g = group ?? "None";
			if (!hasAppSource(name as AppNames, g as AppGroups)) return;
			const src = getAppSource(name as AppNames, g as AppGroups);
			if (src() === value) return;
			src(value);
		},
		get(name: string, group = "None") {
			return AppSources.get(name)?.get(group);
		},
	};
}

function registerApp(
	name: string,
	group: string,
	options: {
		visible?: boolean;
		exclusiveGroup?: string;
		parent?: string;
		parentGroup?: string;
	} = {},
) {
	const entry: AnyAppEntry = {
		name: name as AppNames,
		group: group as AppGroups,
		visible: options.visible ?? false,
		constructor: class {} as any,
		rules: {} as any,
	};

	if (options.exclusiveGroup || options.parent) {
		entry.rules = {
			...(options.exclusiveGroup ? { exclusiveGroup: options.exclusiveGroup } : {}),
			...(options.parent ? { parent: options.parent as AppNames } : {}),
			...(options.parentGroup ? { parentGroup: options.parentGroup as AppGroups } : {}),
		} as any;
	}

	if (!AppRegistry.has(name as AppNames)) {
		AppRegistry.set(name as AppNames, new Map());
	}
	AppRegistry.get(name as AppNames)!.set(group as AppGroups, entry);

	setAppSource(name as AppNames, group as AppGroups, options.visible ?? false);
}

function clearRegistry() {
	AppRegistry.clear();
	AppSources.clear();
}

function isVisible(name: string, group = "lobby"): boolean {
	const src = AppSources.get(name)?.get(group);
	return src ? src() : false;
}

function setupRuleEffects(forge: MockForge) {
	AppRegistry.forEach((entryMap, name) => {
		entryMap.forEach((_, group) => {
			if (!hasAppSource(name, group)) return;
			effect(() => {
				getAppSource(name, group)();
				untrack(() => {
					ParentRule(forge as any, name, group);
					ExclusiveGroupRule(forge as any, name, group);
				});
			});
		});
	});
}

// ------------------------------------------------------------------
// Tests
// ------------------------------------------------------------------

describe("Window Management", () => {
	let forge: MockForge;

	beforeEach(() => {
		clearRegistry();
		forge = createMockForge();
	});

	describe("Basic Operations", () => {
		test("open() sets visibility to true", () => {
			registerApp("store", "lobby", { visible: false });
			forge.open("store", "lobby");
			expect(isVisible("store")).toBe(true);
		});

		test("close() sets visibility to false", () => {
			registerApp("store", "lobby", { visible: true });
			forge.close("store", "lobby");
			expect(isVisible("store")).toBe(false);
		});

		test("apps start with their initial visibility", () => {
			registerApp("summon", "lobby", { visible: true });
			registerApp("store", "lobby", { visible: false });
			expect(isVisible("summon")).toBe(true);
			expect(isVisible("store")).toBe(false);
		});
	});

	describe("ExclusiveGroupRule", () => {
		test("opening one menu closes other menus in same exclusiveGroup", () => {
			registerApp("summon", "lobby", { visible: true, exclusiveGroup: "menus" });
			registerApp("store", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("backpack", "lobby", { visible: false, exclusiveGroup: "menus" });

			setupRuleEffects(forge);

			// Open store — should close summon
			forge.open("store", "lobby");
			expect(isVisible("store")).toBe(true);
			expect(isVisible("summon")).toBe(false);
			expect(isVisible("backpack")).toBe(false);
		});

		test("opening backpack after store closes store", () => {
			registerApp("summon", "lobby", { visible: true, exclusiveGroup: "menus" });
			registerApp("store", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("backpack", "lobby", { visible: false, exclusiveGroup: "menus" });

			setupRuleEffects(forge);

			forge.open("store", "lobby");
			expect(isVisible("store")).toBe(true);
			expect(isVisible("summon")).toBe(false);

			forge.open("backpack", "lobby");
			expect(isVisible("backpack")).toBe(true);
			expect(isVisible("store")).toBe(false);
			expect(isVisible("summon")).toBe(false);
		});

		test("closing a menu doesn't auto-open anything", () => {
			registerApp("summon", "lobby", { visible: true, exclusiveGroup: "menus" });
			registerApp("store", "lobby", { visible: false, exclusiveGroup: "menus" });

			setupRuleEffects(forge);

			forge.open("store", "lobby");
			expect(isVisible("store")).toBe(true);
			expect(isVisible("summon")).toBe(false);

			forge.close("store", "lobby");
			expect(isVisible("store")).toBe(false);
			expect(isVisible("summon")).toBe(false);
		});

		test("apps without exclusiveGroup are NOT affected", () => {
			registerApp("summon", "lobby", { visible: true, exclusiveGroup: "menus" });
			registerApp("leftside", "lobby", { visible: true }); // no exclusiveGroup
			registerApp("store", "lobby", { visible: false, exclusiveGroup: "menus" });

			setupRuleEffects(forge);

			forge.open("store", "lobby");
			expect(isVisible("store")).toBe(true);
			expect(isVisible("summon")).toBe(false);
			expect(isVisible("leftside")).toBe(true); // should NOT be affected
		});

		test("apps in different exclusiveGroups don't interfere", () => {
			registerApp("summon", "lobby", { visible: true, exclusiveGroup: "menus" });
			registerApp("settings", "shared", { visible: false, exclusiveGroup: "overlays" });

			setupRuleEffects(forge);

			forge.open("settings", "shared");
			expect(isVisible("settings", "shared")).toBe(true);
			expect(isVisible("summon")).toBe(true); // different group — unaffected
		});

		test("all 16 menu apps: only one visible at a time", () => {
			const menuApps = [
				"summon",
				"store",
				"backpack",
				"quests",
				"index",
				"dojo",
				"profile",
				"challenges",
				"matches",
				"stat_reroll",
				"trait_reroll",
				"updatelog",
				"stage_info",
				"stage_select",
				"stage_start",
				"stage_friend_invite",
			];

			// Register all with exclusiveGroup: "menus"
			menuApps.forEach((name, i) => {
				registerApp(name, "lobby", {
					visible: i === 0, // only summon starts visible
					exclusiveGroup: "menus",
				});
			});

			setupRuleEffects(forge);

			// Summon should be the only visible one
			expect(isVisible("summon")).toBe(true);
			menuApps.slice(1).forEach((name) => {
				expect(isVisible(name)).toBe(false);
			});

			// Open each one in sequence — only the opened one should be visible
			for (const name of menuApps) {
				forge.open(name, "lobby");
				for (const other of menuApps) {
					if (other === name) {
						expect(isVisible(other)).toBe(true);
					} else {
						expect(isVisible(other)).toBe(false);
					}
				}
			}
		});
	});

	describe("ParentRule", () => {
		test("closing parent closes children", () => {
			registerApp("leftside", "lobby", { visible: true });
			registerApp("store", "lobby", {
				visible: true,
				exclusiveGroup: "menus",
				parent: "leftside",
				parentGroup: "lobby",
			});

			setupRuleEffects(forge);

			forge.close("leftside", "lobby");
			expect(isVisible("leftside")).toBe(false);
			expect(isVisible("store")).toBe(false);
		});

		test("reopening parent restores children's previous state", () => {
			registerApp("leftside", "lobby", { visible: true });
			registerApp("store", "lobby", {
				visible: true,
				exclusiveGroup: "menus",
				parent: "leftside",
				parentGroup: "lobby",
			});
			registerApp("backpack", "lobby", {
				visible: false,
				exclusiveGroup: "menus",
				parent: "leftside",
				parentGroup: "lobby",
			});

			setupRuleEffects(forge);

			// Store is open, backpack is closed
			expect(isVisible("store")).toBe(true);
			expect(isVisible("backpack")).toBe(false);

			// Close parent
			forge.close("leftside", "lobby");
			expect(isVisible("store")).toBe(false);
			expect(isVisible("backpack")).toBe(false);

			// Reopen parent — store should restore to true, backpack to false
			forge.open("leftside", "lobby");
			expect(isVisible("store")).toBe(true);
			expect(isVisible("backpack")).toBe(false);
		});

		test("children of different parents don't interfere", () => {
			registerApp("leftside", "lobby", { visible: true });
			registerApp("rightside", "lobby", { visible: true });
			registerApp("store", "lobby", {
				visible: true,
				exclusiveGroup: "menus",
				parent: "leftside",
				parentGroup: "lobby",
			});
			registerApp("rewards", "lobby", {
				visible: false,
				parent: "rightside",
				parentGroup: "lobby",
			});

			setupRuleEffects(forge);

			forge.close("leftside", "lobby");
			expect(isVisible("store")).toBe(false);
			expect(isVisible("rewards")).toBe(false); // rightside is still open, rewards stays
		});
	});

	describe("Sidebar Behavior", () => {
		test("leftside stays visible when a menu opens", () => {
			registerApp("leftside", "lobby", { visible: true });
			registerApp("summon", "lobby", { visible: true, exclusiveGroup: "menus" });
			registerApp("store", "lobby", {
				visible: false,
				exclusiveGroup: "menus",
				parent: "leftside",
				parentGroup: "lobby",
			});

			setupRuleEffects(forge);

			forge.open("store", "lobby");
			expect(isVisible("leftside")).toBe(true); // sidebar stays
			expect(isVisible("store")).toBe(true);
			expect(isVisible("summon")).toBe(false); // exclusive rule closes this
		});

		test("rightside stays visible when a menu opens", () => {
			registerApp("rightside", "lobby", { visible: true });
			registerApp("summon", "lobby", { visible: true, exclusiveGroup: "menus" });
			registerApp("store", "lobby", {
				visible: false,
				exclusiveGroup: "menus",
			});

			setupRuleEffects(forge);

			forge.open("store", "lobby");
			expect(isVisible("rightside")).toBe(true); // sidebar stays
			expect(isVisible("store")).toBe(true);
		});
	});

	describe("Full Lobby Simulation", () => {
		beforeEach(() => {
			clearRegistry();
			forge = createMockForge();

			// Register all lobby apps exactly as they are in Anime Reborn Interface
			registerApp("leftside", "lobby", { visible: true });
			registerApp("rightside", "lobby", { visible: true });
			registerApp("summon", "lobby", { visible: true, exclusiveGroup: "menus" });
			registerApp("updatelog", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("store", "lobby", {
				visible: false,
				exclusiveGroup: "menus",
				parent: "leftside",
				parentGroup: "lobby",
			});
			registerApp("backpack", "lobby", {
				visible: false,
				exclusiveGroup: "menus",
				parent: "leftside",
				parentGroup: "lobby",
			});
			registerApp("quests", "lobby", {
				visible: false,
				exclusiveGroup: "menus",
				parent: "leftside",
				parentGroup: "lobby",
			});
			registerApp("index", "lobby", {
				visible: false,
				exclusiveGroup: "menus",
				parent: "leftside",
				parentGroup: "lobby",
			});
			registerApp("dojo", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("profile", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("challenges", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("matches", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("stat_reroll", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("trait_reroll", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("stage_info", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("stage_select", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("stage_start", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("stage_friend_invite", "lobby", { visible: false, exclusiveGroup: "menus" });
			registerApp("hotbar", "shared", { visible: true });
			registerApp("teleport", "lobby", { visible: false });
			registerApp("areas", "lobby", { visible: false });
			registerApp("daily_rewards", "lobby", { visible: false });
			registerApp("gold_shop", "lobby", { visible: false });
			registerApp("level_milestone", "lobby", { visible: false });

			setupRuleEffects(forge);
		});

		test("initial state: summon visible, sidebars visible, menus closed", () => {
			expect(isVisible("summon")).toBe(true);
			expect(isVisible("leftside")).toBe(true);
			expect(isVisible("rightside")).toBe(true);
			expect(isVisible("store")).toBe(false);
			expect(isVisible("backpack")).toBe(false);
		});

		test("click Store button: store opens, summon closes, sidebars stay", () => {
			forge.open("store", "lobby");
			expect(isVisible("store")).toBe(true);
			expect(isVisible("summon")).toBe(false);
			expect(isVisible("leftside")).toBe(true);
			expect(isVisible("rightside")).toBe(true);
		});

		test("click Backpack after Store: backpack opens, store closes", () => {
			forge.open("store", "lobby");
			forge.open("backpack", "lobby");
			expect(isVisible("backpack")).toBe(true);
			expect(isVisible("store")).toBe(false);
			expect(isVisible("summon")).toBe(false);
		});

		test("close Store: nothing auto-opens, lobby is empty", () => {
			forge.open("store", "lobby");
			forge.close("store", "lobby");
			expect(isVisible("store")).toBe(false);
			expect(isVisible("summon")).toBe(false); // stays closed
			expect(isVisible("leftside")).toBe(true);
		});

		test("non-exclusive apps (teleport, areas) don't close menus", () => {
			expect(isVisible("summon")).toBe(true);
			forge.open("teleport", "lobby");
			expect(isVisible("teleport")).toBe(true);
			expect(isVisible("summon")).toBe(true); // no exclusiveGroup on teleport
		});

		test("hotbar in different group is unaffected by menu changes", () => {
			expect(isVisible("hotbar", "shared")).toBe(true);
			forge.open("store", "lobby");
			expect(isVisible("hotbar", "shared")).toBe(true);
		});

		test("rapid menu switching: each transition correct", () => {
			const menus = ["store", "backpack", "quests", "index", "dojo", "profile", "challenges"];

			for (const menu of menus) {
				forge.open(menu, "lobby");
				for (const other of menus) {
					expect(isVisible(other)).toBe(other === menu);
				}
				expect(isVisible("summon")).toBe(false);
				expect(isVisible("leftside")).toBe(true);
			}
		});
	});
});
