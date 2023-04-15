# auto-switch theme

## python3 requirement

1. Astral 2.2

## shell requirement

1. issue:No such schema “org.gnome.shell.extensions.user-theme”
   fix it by

    ```shell
    bash gnome/fix_user_theme.sh
    ```
2. init
   ```shell
   bash init.sh
   ```

## 自定义配置
所有的主题配置都放在`config/config.yml`中。

- `location`是城市的经纬度，

- `themes`用来管理是否自动切换，每一个item都需要一个APP配置

- `APP`用来配置不同程序的配置路径及主题名
   目前只支持gnome-desktop、gnome-terminal、terminator、vim、spaceVim等应用，网页可以使用[darkreader](https://github.com/darkreader/darkreader)