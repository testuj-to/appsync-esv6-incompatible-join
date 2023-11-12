
export function request(ctx) {
    return {
        payload: ["foo", null].join("/"),
    }
}

export function response(ctx) {
    return ctx.result
}
