import type Types from "../types/index";
export default function App<N extends AppNames>(props: Types.Decorator.AppProps<N>): <T extends Types.Decorator.Constructor<N>>(constructor: T) => T;
