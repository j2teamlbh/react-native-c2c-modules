import { NativeModules } from 'react-native';

interface PhAssetInfo {
  id: string;
  quality: 'original' | 'high' | 'medium' | 'low';
}

type C2CModulesType = {
  convertPHAsset({ id, quality }: PhAssetInfo): Promise<string>;
};

const { C2CModules } = NativeModules;

export default C2CModules as C2CModulesType;
