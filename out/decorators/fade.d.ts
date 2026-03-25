export default function Fade(period?: number, dampeningRatio?: number): <T extends new (...args: any[]) => {}>(ctor: T) => T;
