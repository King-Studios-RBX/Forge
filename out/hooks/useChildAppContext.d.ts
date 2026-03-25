export default function useChildAppContext<T extends Record<string, unknown> = {}>(): import("../index").ChildArgs & T;
