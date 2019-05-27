<?php
class Horde_Hooks
{
   public function prefs_init($pref, $value, $username, $scope_ob)
   {
      switch ($pref) {
      case 'from_addr':
           if (is_null($username)) {
               return $value;
           }
           return $username . '@localhost';
      }
   }
}