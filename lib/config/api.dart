class Api {
  static const _host = 'http://192.168.43.37/api_ecommerce_shoes';
  static const _hostCart = '$_host/cart';
  static const _hostOrder = '$_host/order';
  static const _hostShoes = '$_host/shoes';
  static const _hostUser = '$_host/user';
  static const _hostWishlist = '$_host/wishlist';
  static const hostImage = '$_host/images/';

  // Cart
  static const addCart = '$_hostCart/add.php';
  static const deleteCart = '$_hostCart/delete.php';
  static const getCart = '$_hostCart/get.php';
  static const updateCart = '$_hostCart/update.php';

  // Order
  static const addOrder = '$_hostOrder/add.php';
  static const deleteOrder = '$_hostOrder/delete.php';
  static const getHistory = '$_hostOrder/get_history.php';
  static const getOrder = '$_hostOrder/get_order.php';
  static const setArrived = '$_hostOrder/set_arrived.php';

  // Shoes
  static const searchShoes = '$_hostShoes/search.php';
  static const getAllShoes = '$_hostShoes/get_all.php';
  static const getPopularShoes = '$_hostShoes/get_popular.php';

  // User
  static const checkEmail = '$_hostUser/check_email.php';
  static const login = '$_hostUser/login.php';
  static const register = '$_hostUser/register.php';

  // Wishlist
  static const addWhislist = '$_hostWishlist/add.php';
  static const checkWhislist = '$_hostWishlist/check.php';
  static const deleteWhislist = '$_hostWishlist/delete.php';
  static const getWishlist = '$_hostWishlist/get.php';
}
