type EventLike<T extends Callback = Callback> = {
    Connect(callback: T): ConnectionLike;
} | {
    connect(callback: T): ConnectionLike;
} | {
    subscribe(callback: T): ConnectionLike;
};
type ConnectionLike = {
    Disconnect(): void;
} | {
    disconnect(): void;
} | (() => void);
/**
 * Subscribes to an event-like object. The subscription is automatically
 * disconnected when the scope cleans up.
 *
 * @param event The event-like object to subscribe to.
 * @param listener The listener to subscribe with.
 * @returns The connection object.
 */
export default function useEventListener<T extends EventLike>(event: T, listener: T extends EventLike<infer U> ? U : never): ReturnType<T>;
export {};
