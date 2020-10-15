import * as React from 'react';
import CameraRoll from '@react-native-community/cameraroll';
import {
  StyleSheet,
  View,
  Platform,
  Text,
  Button,
  FlatList,
} from 'react-native';
import C2CModules from 'react-native-c2c-modules';

export default function App() {
  const [dataVideo, setDataVideo] = React.useState<any>([]);
  const [resultData, setResultData] = React.useState<any>();

  React.useEffect(() => {
    if (Platform.OS === 'ios') {
      CameraRoll.getPhotos({
        assetType: 'Videos',
        first: 10,
      }).then((res) => {
        setDataVideo(res.edges);
      });
    }
  }, []);

  const convertVideo = (uri: any) => {
    C2CModules.convertPHAsset({
      id: uri,
    })
      .then((resultItem) => {
        setResultData(resultItem);
      })
      .catch((e) => console.log(e.message));
  };

  return (
    <View style={styles.container}>
      <FlatList
        data={dataVideo}
        renderItem={({ item, index }) => {
          return (
            <Button
              title={`File ${index}`}
              onPress={() => convertVideo(item.node.image.uri)}
            />
          );
        }}
        keyExtractor={(_item, index) => String(index)}
      />
      <Text>Final: {JSON.stringify(resultData)}</Text>
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
