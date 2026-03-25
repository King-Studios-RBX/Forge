export declare const screen: import("@rbxts/vide").Source<Vector2>;
export declare const px: ((value: number) => number) & {
    scale: (value: number) => number;
    even: (value: number) => number;
    floor: (value: number) => number;
    ceil: (value: number) => number;
};
/**
 * Initializes global px scaling.
 * Must be called exactly once.
 */
export declare function usePx(target?: GuiObject | Camera, baseResolution?: Vector2, minScale?: number): void;
