
export function request(ctx) {
    return {
        payload: ["foo", undefined].join("/"),
    }
}

export function response(ctx) {
    return ctx.result
}
