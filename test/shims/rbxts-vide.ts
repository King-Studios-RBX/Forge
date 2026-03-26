// Vide shim for bun test — provides source, effect, untrack, batch
export type Source<T> = (() => T) & ((newValue: T) => void);

let effectQueue: Array<() => void> = [];
let isProcessingEffects = false;

export function source<T>(initial: T): Source<T> {
	let state = initial;
	const subscribers: Set<() => void> = new Set();

	const fn = (...args: unknown[]): T | void => {
		if (args.length === 0) {
			// Read — track current effect
			if (currentEffect) {
				subscribers.add(currentEffect);
			}
			return state;
		}
		const newValue = args[0] as T;
		if (state === newValue) return;
		state = newValue;
		// Notify subscribers
		for (const sub of subscribers) {
			effectQueue.push(sub);
		}
		if (!isProcessingEffects) {
			flushEffects();
		}
	};
	return fn as Source<T>;
}

let currentEffect: (() => void) | null = null;

export function effect(fn: () => void): void {
	const wrappedFn = () => {
		const prev = currentEffect;
		currentEffect = wrappedFn;
		try {
			fn();
		} finally {
			currentEffect = prev;
		}
	};
	// Run immediately to set up subscriptions
	wrappedFn();
}

export function untrack<T>(fn: () => T): T {
	const prev = currentEffect;
	currentEffect = null;
	try {
		return fn();
	} finally {
		currentEffect = prev;
	}
}

export function batch(fn: () => void): void {
	const prevProcessing = isProcessingEffects;
	isProcessingEffects = true;
	try {
		fn();
	} finally {
		isProcessingEffects = prevProcessing;
		if (!isProcessingEffects) {
			flushEffects();
		}
	}
}

function flushEffects(): void {
	isProcessingEffects = true;
	const seen = new Set<() => void>();
	while (effectQueue.length > 0) {
		const batch = effectQueue.splice(0);
		for (const fn of batch) {
			if (!seen.has(fn)) {
				seen.add(fn);
				fn();
			}
		}
	}
	isProcessingEffects = false;
}

// Default export as namespace
const Vide = { source, effect, untrack, batch };
export default Vide;
