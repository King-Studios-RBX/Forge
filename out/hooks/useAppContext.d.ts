export default function useForgeContext<T extends Record<string, unknown> = {}>(): import("../index").Args & T;
