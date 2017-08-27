const ls = window.localStorage;
const prefix = '_lc_';

class CacheService {
  has(name) {}
  get(name) {}
  getOrDefault(name) {}
  set(name) {}
  remove(name) {}
};

class LocalStorageCacheService extends CacheService {
  has(name) {
    var jsonString = ls.getItem(prefix + name);
    return jsonString != null;
  }

  get(name) {
    var jsonString = ls.getItem(prefix + name);

    try {
      return JSON.parse(jsonString);
    } catch (e) {
      return null;
    }
  }

  getOrDefault(key, defaultValue) {
    return this.has(key) ? this.get(key) : defaultValue;
  }

  set(name, data) {
    var jsonString = JSON.stringify(data);
    ls.setItem(prefix + name, jsonString);
  }

  remove(name) {
    ls.removeItem(prefix + name);
  }
};

export default new LocalStorageCacheService();
