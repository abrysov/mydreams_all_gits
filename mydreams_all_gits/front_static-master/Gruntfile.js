var postcss = function(){
    return require('poststylus')([
        //'autoprefixer', - cut nib stylus prefixes!
        'pixrem', // add fallbacks for rem units
        //'cssnext', - also cut nib stylus prefixes!
        //'rucksack-css', /*Automagical responsive typography https://www.npmjs.com/package/rucksack-css*/
        'postcss-initial', /* fallback initial keyword */
        'postcss-discard-comments']);
};

module.exports = function(grunt) {

    grunt.initConfig({

        stylus: {
            compile: {
                options: {
                    use: [
                        postcss /*look at https://github.com/sapegin/csso-stylus*/
                        //,require('axis') /* http://axis.netlify.com/ */
                    ],
                    compress: false
                },
                files: {
                    'output/css/style.css': 'styl/style.styl'
                    //,'output/css/deploy.css': 'styl/deploy.styl'
                }
            }
        },

        haml: {                              // Task
            dev: {                             // Another target
                options: {                       // Target options
                    loadPath: 'particles'
                }
            },
            //loadPath: 'particles',
            dist: {                            // Target
                files: {                         // Dictionary of files
                    'output/main.html': 'haml/layout.haml'
                    //,'output/deploy.html': 'haml/deploy.haml'
                }
            }
        },

        watch: {
            scripts: {
                files: ['/haml/**/*.haml', '/styl/**/*.styl'],
                tasks: [ 'haml', 'stylus' ],
                options: {
                    spawn: false
                    //,livereload: 8888
                }
            }
        }

    });

    grunt.loadNpmTasks('grunt-postcss');
    grunt.loadNpmTasks('grunt-haml2html');
    grunt.loadNpmTasks('grunt-contrib-stylus');

    grunt.loadNpmTasks('grunt-contrib-livereload');
    grunt.loadNpmTasks('grunt-contrib-watch');


    grunt.registerTask('default', ['haml', 'stylus']);

    grunt.registerTask('watch', ['watch']);

};