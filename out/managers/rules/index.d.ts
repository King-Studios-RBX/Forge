import type { AppForge } from "../../forge";
export default class Rules {
    protected processing: Set<string>;
    protected setupRuleEffects(forge: AppForge): void;
    protected checkRules(forge: AppForge, name: AppNames, group: AppGroups): void;
}
