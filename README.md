# hoarder
YouTube archiving script based on youtube-dl
Suitable for manual and automated YouTube video hoarding.

It's basically a youtube-dl launcher with predefined options
and an optional glorified while loop featuring an interactive countdown.

Requires [youtube-dl](http://rg3.github.io/youtube-dl/).

# Configuration

Hoarder needs a directory to both store configuration and download content in.

The `$hoarder_data_dir` can be read from the environment,
or sourced from a `hoarder.cfg` in the current directory.

The `$hoarder_data_dir` needs to contain a textfile called `hoarder_urls.txt`
containing the URLs you want to hoard.

Options for hoarder mode and horder wait interval
can be read from the environment, `$hoarder_mode`, `$hoarder_wait`,

or sourced from a `hoarder.cfg` in the current directory,

or specified as positional parameters (`$1` is mode, `$2` is interval):
`./hoard.sh loop 10`

If no mode is specified, `hoard.sh` defaults to run-once mode.

# How it works

When you start `hoard.sh`, it checks if `$hoarder_data_dir` is set
and if it exists. It also sets defaults for non-critical options that aren't set

It then starts `youtube-dl` with some hard-coded options.

Files are downloaded to `$hoarder_data_dir/<uploader name>/`.

They are named `<uploader-name>-<video tittle>.<file extension>`.

Output container is `.mkv` and subs are downloaded and included where applicable.

youtube-dl saves the IDs to `$hoarder_data_dir/hoarder_archive.txt`,
so that already downloaded content will be skipped next time.

If looping mode is activated, hoard.sh waits the specified interval before
launching `youtube-dl` again

So all you need to do is to add YouTube video/channel/user/playlist URLs and
hoarder will make sure to hoard all those nice videos for you.
