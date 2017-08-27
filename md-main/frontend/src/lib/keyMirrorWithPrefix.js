export default function keyMirrorWithPrefix(data) {
  const result = {};

  Object.keys(data).forEach((key) => {
    data[key].forEach((val) => {
      const newKey = `${key}_${val}`;
      if (!result[key]) {
        result[key] = {};
      }

      result[key][val] = newKey;
    });
  })

  return result;
}

