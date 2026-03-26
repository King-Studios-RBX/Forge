// Test globals
declare global {
	type AppGroups = string;
	type AppNames = string;
	type AppProps = {};
	function error(msg: string, level?: number): never;
	function typeIs(value: unknown, typeName: string): boolean;
	var debug: { traceback: () => string };
}

// Shim debug.traceback
(globalThis as any).debug = { traceback: () => "test-traceback" };

export {};
