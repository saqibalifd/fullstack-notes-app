const app = require('./src/app');
const connectDB = require('./src/db/db');
const noteModel = require('./src/models/note.model');

connectDB();


// CREATE NOTE (POST)

app.post('/notes', async (req, res) => {
    try {
        const { title, description } = req.body;

        if (!title || !description) {
            return res.status(400).json({
                message: 'Title and description are required'
            });
        }

        const note = await noteModel.create({ title, description });

        console.log('POST /notes hit');

        res.status(201).json({
            message: 'Note added successfully',
            note
        });

    } catch (error) {
        res.status(500).json({
            message: 'Server error',
            error: error.message
        });
    }
});



// READ NOTES (GET)

app.get('/notes', async (req, res) => {
    try {
        const notes = await noteModel.find();

        console.log('GET /notes hit');

        res.status(200).json({
            message: 'Notes fetched successfully',
            count: notes.length,
            notes
        });

    } catch (error) {
        res.status(500).json({
            message: 'Server error',
            error: error.message
        });
    }
});



// DELETE NOTE (DELETE)

app.delete('/notes/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const deletedNote = await noteModel.findByIdAndDelete(id);

        if (!deletedNote) {
            return res.status(404).json({
                message: 'Note not found'
            });
        }

        console.log('DELETE /notes/:id hit');

        res.status(200).json({
            message: 'Note deleted successfully',
            deletedNote
        });

    } catch (error) {
        res.status(500).json({
            message: 'Server error',
            error: error.message
        });
    }
});



// UPDATE NOTE (PATCH)

app.patch('/notes/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { title, description } = req.body;

        const updatedNote = await noteModel.findByIdAndUpdate(
            id,
            { title, description },
            { returnDocument: 'after', runValidators: true }
        );

        if (!updatedNote) {
            return res.status(404).json({
                message: 'Note not found'
            });
        }

        console.log('PATCH /notes/:id hit');

        res.status(200).json({
            message: 'Note updated successfully',
            updatedNote
        });

    } catch (error) {
        res.status(500).json({
            message: 'Server error',
            error: error.message
        });
    }
});



// START SERVER

const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server started at port: ${PORT}`);
});