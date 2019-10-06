import NodeCache from 'node-cache';


class Cache {
    constructor(stdTTL) {
        this.cache = new NodeCache({
            stdTTL,
            checkperiod: stdTTL * 0.2,
            useClones: false
        })
    }
    get(key, storeFunction) {
        const storedValue = this.cache.get(key);
        if (storedValue) {
            return Promise.resolve(storedValue)
        }
        return storeFunction()
            .then(result => {
                this.cache.set(key, result);
                return result;
            })
    }
    del(keys) {
        this.cache.del(keys);
    }
    delStartWith(startWithStr = '') {
        if (!startWithStr) {
            return;
        }
        const keys = this.cache.keys();
        for (const key of keys) {
            if (key.indexOf(startWithStr) === 0) {
                this.del(key);
            }
        }
    }
    flush() {
        this.cache.flushAll();
    }
}

export default Cache;