import type Types from "../types/index";
export default function ChildApp<N extends AppNames>(props: Types.Decorator.ChildAppProps<N>): <T extends Types.Decorator.ChildConstructor<N>>(constructor: T) => T;
