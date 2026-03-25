import type Types from "../types/index";
/**
 * Type guard to check if a rules object is a ChildApp (i.e., has a parent or is a child type)
 */
export default function isChildAppRules(rules?: Types.Rules.App | Types.Rules.ChildApp): rules is Types.Rules.ChildApp;
