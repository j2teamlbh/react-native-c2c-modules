import { NativeModules, Platform } from 'react-native';

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
   * Convert PHAsset to AVAsset
   * IOS Only
   */
  convertPHAsset({ id, quality }: PhAssetInfo): Promise<PHAssetResponse>;
  /**
   * Change screen to fullscreen
   * Android Only
   */
  onFullScreen(): void;
  /**
   * Change screen to normal
   * Android Only
   */
  offFullScreen(): void;
};
const { C2CModules } = NativeModules;

const onFullScreen = () => {
  if (Platform.OS === 'android') {
    C2CModules.onFullScreen();
  }
};

const offFullScreen = () => {
  if (Platform.OS === 'android') {
    C2CModules.onFullScreen();
  }
};

const convertPHAsset = ({ id, quality }: PhAssetInfo) => {
  if (Platform.OS === 'ios') {
    C2CModules.convertPHAsset({ id, quality });
  }
};

export default {
  onFullScreen,
  convertPHAsset,
  offFullScreen,
} as C2CModulesType;
