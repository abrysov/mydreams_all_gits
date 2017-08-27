import "moment";
import "moment/locale/ru";

import { store, history } from "./AppStore";
import messengerWs from "lib/messengerWs";

import LikesModal from "./widgets/LikesModal";
import GiftModals from "./widgets/GiftModals";
import BuyCoinsForm from "./widgets/BuyCoinsForm";
import CertificatesListWidget from "./widgets/CertificatesList";
import DreamPage from "./widgets/DreamPage";
import DreamerInfo from "./widgets/DreamerInfo";
import CreateDream from "./widgets/CreateDream";
import UpdatesFeed from "./widgets/UpdatesFeed";
import EventsFeed from "./widgets/EventsFeed";
import PostsFeed from "./widgets/PostsFeed";
import NotificationsList from "./widgets/NotificationsList";
import LeadersBar from "./widgets/LeadersBar";
import DreamsListWidget from "./widgets/DreamsList";
import FulfilledDreamsListWidget from "./widgets/FulfilledDreamsList";
import DreamersListWidget from "./widgets/DreamersList";
import UserLeftMenu from "./widgets/UserLeftMenu";
import PhotoAlbum from "./widgets/PhotoAlbum";
import UserSettings from "./widgets/UserSettings";
import Messenger from "./widgets/Messenger";
import PhotoViewer from "./widgets/PhotoViewer";

window.MyDreams = {
  LikesModal,
  GiftModals,
  BuyCoinsForm,
  CertificatesListWidget,
  DreamPage,
  DreamerInfo,
  CreateDream,
  UpdatesFeed,
  EventsFeed,
  PostsFeed,
  NotificationsList,
  LeadersBar,
  DreamsListWidget,
  FulfilledDreamsListWidget,
  DreamersListWidget,
  UserLeftMenu,
  PhotoAlbum,
  UserSettings,

  Messenger,
  PhotoViewer,

  store,
  history
};


messengerWs.connect(gon.token);
