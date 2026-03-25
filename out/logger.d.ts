declare const Logger: {
    /**
     * Enable or disable debug logging.
     * Should be called before CreateForge is instantiated.
     */
    setDebug: (enabled: boolean) => void;
    /**
     * General debug log — only prints when debug mode is enabled.
     */
    debug: (context: string, message: string) => void;
    /**
     * Always prints a warning.
     */
    warn: (context: string, message: string) => void;
    /**
     * Always throws an error.
     */
    error: (context: string, message: string) => never;
    /**
     * Times how long a render function takes and logs it if debug is enabled.
     * Returns whatever the callback returns.
     */
    time: <T>(context: string, name: string, fn: () => T) => T;
};
export default Logger;
