import { NativeModules, Platform } from 'react-native';
type C2CModulesType = {
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
   * Set badge number
   * Android Only
   */
  setNotificationBadge(count: number): void;
  /**
   * Reset badge number
   * Android Only
   */
  removeNotificationBadge(): void;
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

const setNotificationBadge = (count: number) => {
  if (Platform.OS === 'android') {
    return C2CModules.setNotificationBadge(count);
  }
};

const removeNotificationBadge = () => {
  if (Platform.OS === 'android') {
    return C2CModules.removeNotificationBadge();
  }
};

export default {
  onFullScreen,
  offFullScreen,
  setNotificationBadge,
  removeNotificationBadge,
} as C2CModulesType;
