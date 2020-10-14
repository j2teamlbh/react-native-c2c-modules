import * as React from 'react';
import CameraRoll from '@react-native-community/cameraroll';
import { StyleSheet, View, Platform, Text } from 'react-native';
import C2CModules from 'react-native-c2c-modules';

export default function App() {
  const [originUrl, setOriginUrl] = React.useState<string | undefined>();
  const [result, setResult] = React.useState<string | undefined>();

  React.useEffect(() => {
    if (Platform.OS === 'ios') {
      CameraRoll.getPhotos({ assetType: 'Photos', first: 10 }).then((res) => {
        C2CModules.convertPHAsset({
          id: res.edges[0].node.image.uri,
          quality: 'original',
        })
          .then((item) => {
            setOriginUrl(res.edges[0].node.image.uri);
            setResult(item);
          })
          .catch((e) => console.log(e.message));
      });
    }
  }, []);

  return (
    <View style={styles.container}>
      <Text>Origin: {originUrl}</Text>
      <Text>Result: {result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
