import type Types from "../types/index";
/**
 * Type guard to check if a registry entry is a ChildEntry
 */
export default function isChildEntry(entry?: Types.Decorator.Entry | Types.Decorator.ChildEntry): entry is Types.Decorator.ChildEntry;
