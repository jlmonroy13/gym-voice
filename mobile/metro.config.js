const {getDefaultConfig} = require('metro-config');

module.exports = (async () => {
  const {
    resolver: {sourceExts},
  } = await getDefaultConfig();
  return {
    transformer: {
      babelTransformerPath: require.resolve('metro-react-native-babel-preset'),
    },
    resolver: {
      sourceExts: [...sourceExts, 'cjs'],
    },
  };
})();
