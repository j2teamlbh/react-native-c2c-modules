import { NativeModules } from 'react-native';

export interface PhAssetInfo {
  id: string;
  quality?: 'original' | 'high' | 'medium' | 'low';
}

export interface PHAssetResponse {
  type: string;
  filename: string;
  path: string;
  mimeType: string;
}

type C2CModulesType = {
  /**
   * IOS Only
   */
  convertPHAsset({ id, quality }: PhAssetInfo): Promise<PHAssetResponse>;
};

const { C2CModules } = NativeModules;

export default C2CModules as C2CModulesType;
