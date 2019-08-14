export function stringify(obj) {
    // Placeholder text
    const placeholder = '____PLACEHOLDER____';

    // Keep a list of functions
    const fns = [];

    // Stringify
    let json = JSON.stringify(
        obj,
        (key, value) => {
            if (typeof value === 'function') {
                fns.push(value);
                return placeholder;
            }
            return value;
        },
        2
    );

    // Add functions back
    json = json.replace(new RegExp(`"${placeholder}"`, 'g'), () => fns.shift());

    return `${json}`;
}
