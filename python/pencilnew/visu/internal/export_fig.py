
def export_figure(fig, filepath, filename=False,
                    PNG=True, PDF=False, EPS=False, DPI=300, EXPORT_BBOX_INCES='tight',
                    timestamp=False):
    """Does a proper export of a figure handle to all kind of image files.
    """
    import datetime as dt
    from os.path import join
    from pencilnew.io import exists, mkdir

    ######## parse filepath and filename
    if not filename:
        filepath = os.path.split(filepath)
        filename = filepath[-1]
        filepath = filepath[0]

    if filepath == '': filepath = '.'

    filename = filename.strip()
    filepath = filepath.strip()
    complete_filepath = os.path.join(filepath, filename)

    mkdir(filepath)

    ######## generate timestamp if demanded
    if (not timestamp):
        timestamp = str(dt.datetime.now())[:-7]
        timestamp = timestamp.replace(" ", "_").replace(":","-")
        complete_filepath = complete_filepath+'_'+timestamp

    ######## do the export
    if PNG:
        fig.savefig(complete_filepath+'.png',
        	bbox_inches = EXPORT_BBOX_INCES,
        	dpi = DPI)
    print('~ .png saved')

    if PDF:
        fig.savefig(complete_filepath+'.pdf',
        	bbox_inches = EXPORT_BBOX_INCES,
        	dpi = DPI)
    print('~ .pdf saved')

    if EPS:
        fig.savefig(complete_filepath+'.png',
        	bbox_inches = EXPORT_BBOX_INCES,
        	dpi = DPI)
    print('~ .eps saved')

    if not PNG and not EPS and not EPS:
        print('? WARNING: NO OUTPUT FILE HAS BEEN PRODUCED !!')
    else:
        print('~ Plots saved to '+complete_filepath)

    return fig
