import { NativeEventEmitter, NativeModules, Platform } from 'react-native';

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

type TypeName = 'photoLibraryChanged';

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
  /**
   * Handle the Limited Photos Library
   * IOS Only
   */
  showLimitedLibrary(): void;
  /**
   * On Photo Libary changed
   * IOS Only
   */
  addListener(typeName: string, callback: (changed: boolean) => void): void;
  /**
   * Check library permission
   * IOS Only
   */
  checkPhotoLibrary(callback: (err: any, res: PermissionType) => void): void;
};
const { C2CModules } = NativeModules;

const onFullScreen = () => {
  if (Platform.OS === 'android') {
    return C2CModules.onFullScreen();
  }
};

const offFullScreen = () => {
  if (Platform.OS === 'android') {
    return C2CModules.offFullScreen();
  }
};

const convertPHAsset = ({ id, quality }: PhAssetInfo) => {
  if (Platform.OS === 'ios') {
    return C2CModules.convertPHAsset({ id, quality });
  }
};

const showLimitedLibrary = () => {
  if (Platform.OS === 'ios') {
    return C2CModules.showLimitedLibrary();
  }
};

type PermissionType =
  | 'notDetermined'
  | 'denied'
  | 'authorized'
  | 'limited'
  | 'blocked';

const checkPhotoLibrary = (
  callback: (err: any, res: PermissionType) => void
) => {
  if (Platform.OS === 'ios') {
    return C2CModules.checkPhotoLibrary(callback);
  }
};

const addListener = (
  typeName: TypeName,
  callback: (changed: boolean) => void
) => {
  const eventEmitter = new NativeEventEmitter(C2CModules);
  return eventEmitter.addListener(typeName, callback);
};

export default {
  onFullScreen,
  convertPHAsset,
  offFullScreen,
  showLimitedLibrary,
  addListener,
  checkPhotoLibrary,
} as C2CModulesType;
