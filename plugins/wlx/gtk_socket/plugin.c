#define _GNU_SOURCE
#include <gtk/gtk.h>
#include <gdk/gdkx.h>
#include <dlfcn.h>
#include <glib.h>
#include <string.h>
#include "wlxplugin.h"

#define _plgname "gtk_socket.wlx"

static char cfg_path[PATH_MAX];
static char plug_path[PATH_MAX];
const char* cfg_file = "settings.ini";

gchar *get_file_ext(const gchar *Filename)
{
	if (g_file_test(Filename, G_FILE_TEST_IS_DIR))
		return NULL;

	gchar *basename, *result, *tmpval;

	basename = g_path_get_basename(Filename);
	result = g_strrstr(basename, ".");

	if (result)
	{
		if (g_strcmp0(result, basename) != 0)
		{
			tmpval = g_strdup_printf("%s", result + 1);
			result = g_ascii_strdown(tmpval, -1);
			g_free(tmpval);
		}
		else
			result = NULL;
	}

	g_free(basename);

	return result;
}

const gchar *get_mime_type(const gchar *Filename)
{
	GFile *gfile = g_file_new_for_path(Filename);

	if (!gfile)
		return NULL;

	GFileInfo *fileinfo = g_file_query_info(gfile, G_FILE_ATTRIBUTE_STANDARD_CONTENT_TYPE, 0, NULL, NULL);

	if (!fileinfo)
		return NULL;

	const gchar *content_type = g_strdup(g_file_info_get_content_type(fileinfo));
	g_object_unref(fileinfo);
	g_object_unref(gfile);

	return content_type;
}

static gchar *cfg_get_command(GKeyFile *Cfg, const gchar *Group)
{
	gchar *result, *cfg_value, *tmp = NULL;
	cfg_value = g_key_file_get_string(Cfg, Group, "script", NULL);

	if (!cfg_value)
	{
		result = g_key_file_get_string(Cfg, Group, "command", NULL);

		if ((!result) || (!g_strrstr(result, "$FILE")) || (!g_strrstr(result, "$XID")))
			result = NULL;
	}
	else
	{
		tmp = g_strdup_printf("%s/scripts/%s", plug_path, cfg_value);

		if (g_file_test(tmp, G_FILE_TEST_EXISTS))
			result = g_strdup_printf("%s $XID $FILE", g_shell_quote(tmp));
		else if (g_file_test(cfg_value, G_FILE_TEST_EXISTS))
			result = g_strdup_printf("%s $XID $FILE", cfg_value);
		else
			result = NULL;
	}

	if (tmp)
		g_free(tmp);

	return result;
}

gchar *str_replace(gchar *text, gchar *str, gchar *repl)
{
	gchar **split = g_strsplit(text, str, -1);
	gchar *result = g_strjoinv(repl, split);
	g_strfreev(split);
	return result;
}

gchar *cfg_chk_redirect(GKeyFile *Cfg, const gchar *Group)
{
	gchar *result, *redirect;
	redirect = g_key_file_get_string(Cfg, Group, "redirect", NULL);

	if (redirect)
		return redirect;
	else
		return g_strdup(Group);
}

HWND DCPCALL ListLoad(HWND ParentWin, char* FileToLoad, int ShowFlags)
{
	GKeyFile *cfg;
	GError *err = NULL;
	GtkWidget *gFix;
	GtkWidget *socket;
	const gchar *file_ext, *mime_type;
	gchar *command;
	gchar *group = NULL;
	gboolean noquote;

	mime_type = get_mime_type(FileToLoad);
	file_ext = get_file_ext(FileToLoad);

	cfg = g_key_file_new();

	if (!g_key_file_load_from_file(cfg, cfg_path, G_KEY_FILE_KEEP_COMMENTS, &err))
		g_print("%s (%s): %s\n", _plgname, cfg_path, (err)->message);
	else
	{
		if (file_ext)
		{
			group = cfg_chk_redirect(cfg, file_ext);
			command = cfg_get_command(cfg, group);
		}

		if (mime_type && (!file_ext || !command))
		{
			group = cfg_chk_redirect(cfg, mime_type);
			command = cfg_get_command(cfg, group);
		}

		noquote = g_key_file_get_boolean(cfg, group, "noquote", NULL);
	}

	g_key_file_free(cfg);

	if (err)
		g_error_free(err);

	if (group)
		g_free(group);

	if (!command)
		return NULL;

	gFix = gtk_vbox_new(FALSE, 5);
	gtk_container_add(GTK_CONTAINER(GTK_WIDGET(ParentWin)), gFix);
	socket = gtk_socket_new();
	gtk_container_add(GTK_CONTAINER(gFix), socket);

	GdkNativeWindow id = gtk_socket_get_id(GTK_SOCKET(socket));

	command = str_replace(command, "$FILE", noquote ? FileToLoad : g_shell_quote(FileToLoad));
	command = str_replace(command, "$XID", g_strdup_printf("%d", id));
	g_print("%s\n", command);

	if (!g_spawn_command_line_async(command, NULL))
	{
		gtk_widget_destroy(gFix);
		return NULL;
	}

	gtk_widget_show_all(gFix);
	return gFix;

}

void DCPCALL ListCloseWindow(HWND ListWin)
{
	gtk_widget_destroy(GTK_WIDGET(ListWin));
}

int DCPCALL ListSearchDialog(HWND ListWin, int FindNext)
{
	return LISTPLUGIN_OK;
}

int DCPCALL ListSendCommand(HWND ListWin, int Command, int Parameter)
{

	if (Command == lc_copy)
		gtk_clipboard_set_text(gtk_clipboard_get(GDK_SELECTION_CLIPBOARD),
		                       gtk_clipboard_wait_for_text(gtk_clipboard_get(GDK_SELECTION_PRIMARY)), -1);

	return LISTPLUGIN_OK;
}

void DCPCALL ListSetDefaultParams(ListDefaultParamStruct* dps)
{
	Dl_info dlinfo;

	memset(&dlinfo, 0, sizeof(dlinfo));

	if (dladdr(cfg_path, &dlinfo) != 0)
	{
		strncpy(cfg_path, dlinfo.dli_fname, PATH_MAX);
		strncpy(plug_path, g_path_get_dirname(cfg_path), PATH_MAX);
		char *pos = strrchr(cfg_path, '/');

		if (pos)
			strcpy(pos + 1, cfg_file);
	}
}
