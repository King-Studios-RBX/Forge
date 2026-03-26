// Roblox globals shim for bun test
(globalThis as Record<string, unknown>).error = (msg: string, level?: number) => {
	throw new Error(msg);
};

(globalThis as Record<string, unknown>).warn = (msg: string) => {
	console.warn(msg);
};

(globalThis as Record<string, unknown>).print = (...args: unknown[]) => {
	console.log(...args);
};

(globalThis as Record<string, unknown>).typeIs = (value: unknown, typeName: string): boolean => {
	if (typeName === "string") return typeof value === "string";
	if (typeName === "number") return typeof value === "number";
	if (typeName === "boolean") return typeof value === "boolean";
	if (typeName === "table") return typeof value === "object" && value !== null;
	if (typeName === "function") return typeof value === "function";
	if (typeName === "nil") return value === undefined || value === null;
	return false;
};

(globalThis as Record<string, unknown>).pairs = function* <T extends object>(t: T) {
	for (const [k, v] of Object.entries(t)) {
		yield [k, v] as const;
	}
};

(globalThis as Record<string, unknown>).task = {
	defer: (fn: () => void) => setTimeout(fn, 0),
	spawn: (fn: () => void) => setTimeout(fn, 0),
	wait: (t: number) => new Promise((r) => setTimeout(r, t * 1000)),
};
